# Docker nginx

Allows running static sites within nginx. Map the web content at ```/usr/share/node/var/bin```. For instance:

```
docker rm peerbelt-saas; \
	docker run -it \
		-v /Users/Mac/Work/Peerbelt/pb-core-saas-website/dist:/usr/share/node/var/bin \
		-v /Users/Mac/Work/Peerbelt/docker-nginx/logs:/usr/share/node/var/logs \
		-e SITE=pb-core-saas-website \
		-e PORT=80 \
		-p 8888:80 \
		--name "peerbelt-saas" \
		peerbelt/nginx:x86_64
```

You can also map the entire ```var``` assuming it has the following structure:

```
var
 |- bin
 |- config
 |- health
 |- logs
```

```config``` should contain ```website.nginx``` instance, customized for this particular container. See the default file in this repo.

```health``` should contain any healthcheck in addition to the default check connecting to http://<HOST>:<PORT>. The container comes with ```curl```, ```jq```, and ```lsof``` so writing checks is greatly simplified.

```logs``` is where the ```<SITE>.log``` and ```<SITE>.err.log``` go (should you provide custom ```website.nginx```, the log names may differ - your preference will be taking effect).
