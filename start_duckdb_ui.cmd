@echo off
duckdb -cmd "INSTALL ui;LOAD ui;CALL start_ui();"
