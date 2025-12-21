#!/usr/bin/env bash

projects="/home/sowmiyan/projects/**"

project=$(printf "%s\n" $projects | fzf)

SESSION=$project
PROJECT_DIR="$project"

echo "session $SESSION"
echo "project dir $PROJECT_DIR"

# I have to try to check if the file called tmux.sh exists
# if it does means then it is my best configuration for that project
# otherwise i have to create a new config

cd $PROJECT_DIR
if [ -f "tmux.sh" ]
then
    echo "found tmux.sh running it"
    bash "$PROJECT_DIR/tmux.sh" "$SESSION" "$PROJECT_DIR"
    if [ $? -eq 0 ]
    then
        echo "exited successfully"
        exit 0
    fi
else
    echo "cannot find tmux.sh so creating a new tmux session with a vim and terminal windows"
    tmux has-session -t $SESSION 2>/dev/null

    
    if [ $? = 0 ]; then
        echo "Session $SESSION already exists, Attaching now."
        tmux attach -t $SESSION
        exit 0
    fi

    echo "Creating new Tmux session: $SESSION..."

    tmux new-session -d -s $SESSION -n "Editor"

    tmux send-keys -t $SESSION:1 "cd $PROJECT_DIR" C-m

    tmux send-keys -t $SESSION:1 "vim ." C-m

    tmux new-window -t $SESSION:3 -n "Term"

    tmux send-keys -t $SESSION:3 "cd $PROJECT_DIR" C-m

    tmux attach -t $SESSION
fi
