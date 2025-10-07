# promote-solution

This includes two github actions:
- block_pipeline.yml (Will add a .ignore to any file which is not located in a folder which shares the exact name of the pipeline's folder or of the pipeline itself it is not located in a folder. Pipelines MUST have the annotation "Approved".)
- undo_ignore.yml (Undoes .ignore if you do it on accident.)

NOTE: Possible improvement... use Python instead of bash scripts for this one.

Originally made by JPK583
