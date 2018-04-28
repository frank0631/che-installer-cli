
# -*- coding: utf-8 -*-
from __future__ import unicode_literals, absolute_import, print_function
import click
import os
import sys
import pprint
import requests
import json


pp = pprint.PrettyPrinter(indent=4)
ENV_VARS = {
    'KEYCLOAK_API': os.environ.get('KEYCLOAK_API', 'localhost'),
    'KEYCLOAK_USER': os.environ.get('KEYCLOAK_USER'),
    'KEYCLOAK_PASSWORD': os.environ.get('KEYCLOAK_PASSWORD'),
    'KEYCLOAK_PORT': os.environ.get('KEYCLOAK_PORT', '5050'),
    'CHE_HOST': os.environ.get('CHE_HOST', 'localhost'),
    'CHE_PORT': os.environ.get('CHE_PORT', '8080')
}

def getToken():
    token_url = '{KEYCLOAK_API}:{KEYCLOAK_PORT}/auth/realms/che/protocol/openid-connect/token'.format(**ENV_VARS)
#    print(token_url)
    auth_payload = {
        'grant_type': 'password',
        'client_id': 'che-public',
        'username': ENV_VARS['KEYCLOAK_USER'],
        'password': ENV_VARS['KEYCLOAK_PASSWORD']
    }
    auth_request = requests.post(token_url, data=auth_payload)
    auth_response = auth_request.json()
    access_token = auth_response['access_token']
#    pp.pprint(auth_response)
    
#    token_payload = {
#        'grant_type': 'authorization_code',
#        'client_id': 'che-public',
#        'code': access_token
#    }
#    json_header = {'Content-type': 'application/json', 'Accept': 'text/plain'}
#    token_request = requests.post(token_url, data=token_payload)
#    token_response = token_request.json()
#    pp.pprint(token_response)
    
    return access_token


def getInstaller(id, access_token):
    installer_url = '{CHE_HOST}:{CHE_PORT}/api/installer/{id}'.format(**ENV_VARS, id=id)
    token_header = {'Authorization': 'Bearer ' + access_token}
    token_request = requests.get(installer_url, headers=token_header)
    token_response = token_request.json()
    pp.pprint(token_response)


def postInstaller(id, access_token):
    installer_json = json.load(open(id + '.json'))
    installer_script = open((id + '.script.sh'), 'r').read()
    installer_json['script'] = installer_script

    installer_url = '{CHE_HOST}:{CHE_PORT}/api/installer/'.format(**ENV_VARS, id=id)
    token_header = {'content-type': 'application/json', 'Authorization': 'Bearer ' + access_token}
    installer_request = requests.post(installer_url, headers=token_header, json=installer_json)
    installer_response = installer_request.text
    pp.pprint(installer_request)
    pp.pprint(installer_response)


@click.command()
@click.argument('id')
def main(id):
    access_token = getToken()
#    print(access_token)
#    getInstaller(id, access_token)
    postInstaller(id, access_token)
#    print(access_token)
#    print('I am che_install_rest')
