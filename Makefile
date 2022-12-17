ip := `terraform output -raw server_ip`
domain := `terraform output -raw domain`

plan:
		terraform plan

apply:
		terraform apply -auto-approve

showip:
		@echo $(ip)

configure:
		ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i "$(ip)," -u root -e "domain=$(domain)" playbook.yml

destroy:
		terraform destroy -auto-approve

clean:
		rm -rf cert/*

spawn: apply configure

respawn: clean destroy apply configure

showcert:
		@cat ca-cert.pem
