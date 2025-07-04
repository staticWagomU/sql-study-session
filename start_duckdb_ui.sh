#!/bin/bash
duckdb -cmd "INSTALL ui;LOAD ui;CALL start_ui();"
