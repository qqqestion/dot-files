DOT_FILES=()

if [[ !(-e ~/.old_files) ]]
then	
	mkdir ~/.old_files
fi

for FILE in .vimrc .zshrc .tmux.conf
do
	if [[ -e ~/.$FILE ]]
	then
		mv ~/.$FILE ~/.old_files
	fi
	ln $FILE ~/.$FILE
done

