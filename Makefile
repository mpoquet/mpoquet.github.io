nothing:
	@echo "No default target. Please specify one."

static:
	hugo

server:
	hugo server

deploy:
	./deploy_to_master.bash