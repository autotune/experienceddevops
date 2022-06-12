## METRICS
Followed tutorial at: 

https://blog.viktoradam.net/2020/05/11/prometheus-flask-exporter/

https://github.com/rycus86/prometheus\_flask_exporter

#### HPA

Followed tutorial at:

https://learnk8s.io/autoscaling-apps-kubernetes

#### HOW TO USE

Run `kubectl apply -f ./` in each folder. Make sure to change custom values as needed.

#### KEY CHALLENGES 

ServiceMonitor requires specific label selector that matches kind in prometheus object, otherwise target will not show up to be scraped. Finding a decent HPA tutorial that wasn't horribly complex also proved time consuming, as did finding a way to correctly export count metric to prometheus in custom webhook application. 

#### RATIONALE 

I used the default helm values in order to save time and focus on speed of getting this challenge completed. Things I would change in production are noted below. 

#### CAVEATS

There are no ingress rules applied to grafana or prometheus, and therefore no login configured for prometheus, which is terribly insecure. In production I'd change the default admin password for grafana and look for a way to secure prometheus with username/password authentication. I would also use a combination of ingress rules and cert-manager to secure it while opening up to the world at large. I was unable to complete the portion of the challenge for exposing in-flight metrics in flask. 
