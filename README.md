# multi_flow_SDP
Multi-Source Bronze Ingestion with Delta Live Tables (DLT)
Overview

This script demonstrates a multi-flow bronze ingestion pattern in Databricks Delta Live Tables (DLT), where order data from three independent subsidiary companies — each landing in its own storage location and file format — is unified into a single streaming bronze table using Databricks' CREATE FLOW syntax.

This pattern is common in real-world data engineering when multiple business units, source systems, or acquired companies produce structurally similar data that needs to be consolidated into one canonical table without merging the ingestion logic into a single monolithic read.

What It Does
Defines a shared streaming table (orders_bronze_flows_demo) with a fixed schema that all incoming order data will conform to, regardless of source.
Creates three independent flows, each responsible for ingesting from a single subsidiary's data volume:
Bright Home — CSV files with headers
Lumina Sports — CSV files with headers
Northstar Outfitters — JSON files
Each flow reads its source using STREAM read_files() (Databricks' Auto Loader-style streaming file reader), explicitly casts every column to STRING to enforce schema consistency across heterogeneous sources, and writes into the shared bronze table with INSERT INTO ... BY NAME.
Captures file-level lineage on every row using the _metadata column, recording the originating source_file and its file_mod_time — critical for auditability and debugging in a banking/compliance context.
Protects the bronze layer from accidental data loss via pipelines.reset.allowed = false, which prevents a full table refresh (and therefore full reprocessing/reload) of the bronze table.
Why Multiple Flows Instead of One?

Rather than writing a single ingestion query that unions three sources together, this design gives each subsidiary its own independent flow:

Independent failure isolation — if Northstar's JSON files are malformed, Bright Home and Lumina Sports continue ingesting without interruption.
Independent scaling and checkpointing — each flow tracks its own streaming state, so backfills or reprocessing can be scoped to a single source.
Format flexibility — sources can use entirely different file formats (CSV vs. JSON) and still land in the same target table, since schema conformance is enforced at the SELECT level rather than at the source.
Auditability — with source_file and file_mod_time tracked per row, it's straightforward to trace any bronze record back to the exact file and subsidiary it came from.
Architecture Pattern
Bright Home (CSV)         ─┐
Lumina Sports (CSV)        ├─► CREATE FLOW (x3) ─► orders_bronze_flows_demo (Streaming Table)
Northstar Outfitters (JSON)─┘

This is the bronze layer of a medallion architecture — raw data is ingested as-is (all columns cast to STRING) with minimal transformation, preserving the original values for downstream silver-layer cleansing, type casting, and validation.

Tech Stack
Databricks Delta Live Tables (DLT)
Delta Lake streaming tables
Databricks Auto Loader (read_files streaming source)
SQL
