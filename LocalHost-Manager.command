#!/bin/bash

while true; do
  # clean old sessions
  killall node 2>/dev/null
  killall Python 2>/dev/null
  killall python3 2>/dev/null

  clear
  echo "========================================="
  echo " LOCAL HOST MANAGER"
  echo " (old Node/Python sessions cleared)"
  echo "========================================="
  echo "1) Start Python (~/Desktop/testform) on 8000"
  echo "2) Start Node (~/Desktop/testform/logger) on 3010"
  echo "3) Stop all local servers"
  echo "4) Show active ports"
  echo "5) Return to menu"
  echo "6) Start BOTH (Python + Node)"
  echo "7) Quit"
  echo "-----------------------------------------"
  read -p "Select an option [1-7]: " choice
  echo "-----------------------------------------"

  case "$choice" in
    1)
      cd "$HOME/Desktop/testform" || exit 1
      python3 -m http.server 8000 &
      echo "Python running at http://localhost:8000"
      ;;
    2)
      PROJECT_DIR="$HOME/Desktop/testform/logger"
      PORT=3010
      if [ ! -d "$PROJECT_DIR" ]; then
        echo "Logger project not found at $PROJECT_DIR"
      else
        EXISTING_PID=$(lsof -ti tcp:$PORT)
        if [ -n "$EXISTING_PID" ]; then
          kill -9 "$EXISTING_PID" 2>/dev/null
          sleep 1
        fi
        cd "$PROJECT_DIR" || exit 1
        npm start &
        echo "Node running at http://localhost:$PORT"
      fi
      ;;
    3)
      killall node 2>/dev/null
      killall Python 2>/dev/null
      killall python3 2>/dev/null
      echo "All local servers stopped."
      ;;
    4)
      sudo lsof -iTCP -sTCP:LISTEN -n -P
      ;;
    5)
      # do nothing, just re-show menu
      ;;
    6)
      # start python
      cd "$HOME/Desktop/testform" || exit 1
      python3 -m http.server 8000 &
      echo "Python running at http://localhost:8000"

      # start node
      PROJECT_DIR="$HOME/Desktop/testform/logger"
      PORT=3010
      if [ -d "$PROJECT_DIR" ]; then
        EXISTING_PID=$(lsof -ti tcp:$PORT)
        if [ -n "$EXISTING_PID" ]; then
          kill -9 "$EXISTING_PID" 2>/dev/null
          sleep 1
        fi
        cd "$PROJECT_DIR" || exit 1
        npm start &
        echo "Node running at http://localhost:$PORT"
      else
        echo "Logger project not found at $PROJECT_DIR"
      fi
      ;;
    7)
      echo "Exiting."
      break
      ;;
    *)
      echo "Invalid choice."
      ;;
  esac

  echo "-----------------------------------------"
  read -n 1 -s -r -p "Press any key to return to menu..."
done