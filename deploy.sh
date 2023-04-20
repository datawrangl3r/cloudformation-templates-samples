#!/bin/bash

SHORT=s:,t:,h:,p:
LONG=stack:,template:,help:,parameters:
OPTS=$(getopt -a -n weather --options $SHORT --longoptions $LONG -- "$@")

eval set -- "$OPTS"

help()
{
	echo "Deploy Cloud Formation template"
	echo
	echo "Syntax: deploy.sh [-s|-t]"
	echo "-s|--stack      Stack Name"
	echo "-t|--template   Template File"
	echo "-p|--parameters Parameter File"
}

parameter_file='None'

echo $OPTS
while : 
do
	case "$1" in
		-s | --stack)
			stack_name="$2"
			shift 2
			;;
		-t | --template)
			template_file="$2"
			shift 2
			;;
		-p | --parameters)
			parameter_file="$2"
			shift 2
			;;
		-h | --help) #display Help
			help
			exit;;
		--)
			shift;
			break
			;;
		*) #invalid option
			help
			exit;;
	esac

done

if [[ $parameter_file = 'None' ]]; then
	aws cloudformation deploy \
		--stack-name $stack_name \
		--template-file $template_file

else
	parameters=`cat ${parameter_file}`
	aws cloudformation deploy \
		--stack-name $stack_name \
		--template-file $template_file \
		--parameter-overrides $parameters
fi
