HOST=0.0.0.0
PORT=8080


run: runserver

runserver:
	./manage.py runserver $(HOST):$(PORT)
