@echo off
cd /d "%~dp0"
py -m streamlit run dashboardpp.py --server.address 0.0.0.0 --server.port 8501
pause
