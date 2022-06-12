## k8s Manifests 

#### ROCKET CHAT 

Created by following instructions at:


https://docs.rocket.chat/installing-and-updating/paas-deployments/aliyun

To create docker-compose file, used kustomize to convert into kubernetes deployment manifests

#### GitLab

Created by converting docker-compose.yml at https://github.com/BytemarkHosting/configs-gitlab-docker/blob/master/docker-compose.yml with kompose convert.

#### HOW TO USE

Run `kubectl apply -f ./` in each folder. Make sure to change custom values like domain name in gitlab yaml. 


## webhook-app

Followed tutorials at: 

https://blog.bearer.sh/consume-webhooks-with-python/

https://medium.com/appsflyer/gitlab-the-magic-of-system-hooks-f38c4f7ca8e7 

https://www.programmersought.com/article/82764277179/

for initial webhook received portion. For kubernetes manifests I created customized versions of app-deployment.yaml and app-service.yaml files. 


#### How to run

    replace rocketchat login credentials with your own
    python3 app.py 

#### RATIONALE

Used `kompose convert` on docker-compose.yml file as there were various docker-compose files immediately and easily available to consume. Compare this to trying to find up-to-date gitlab or rocket chat manifests that don't use helm and you'd find most are years old and don't work with modern kubernetes version. I prefer to use existing solutions to save time if possible rather than build from scratch. 

#### KEY CHALLENGES 

Finding usable docker-compose file proved challenging as far too many either just didn't work due to age or various syntax issues with having to use docker-compose version 1,2 or 3 to work with kompose with no decimal places allowed, like 2.3. For the api challenge finding prometheus tutorial to use that was actually usable was quite difficult as well as only the first page or so of results in google proved useful. 

#### CAVEATS

GitLab would sometimes randomly fail to register for LetsEncrypt. Used a "guess and check" troubleshooting approach to fix the issue. RocketChat was spun up without encryption/SSL enabled, in production I would use cert-manager to register a SSL certificate. 
