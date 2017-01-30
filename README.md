# play 2.5.12 / activator 1.3.12

This is an [S2I](https://github.com/openshift/source-to-image) image to use to build a play java or scala application in openshift

## Requirements

* [S2I](https://github.com/openshift/source-to-image)
* [Docker](https://www.docker.com/products/docker)


## To build the S2I image

	1. Clone this repository
	2. Execute ```docker build -t play2 .```

## To build an image with your application code
	1. Configure your conf/application.conf file : 
		play.crypto.secret="changeme"
		play.crypto.secret=${?APPLICATION_SECRET} 

	2. ```s2i build git://<source code> --env="APPLICATION_SECRET=<your secret>" play2 <application image>```

## To run your image with Docker

```docker run -it -p 9000:9000 --rm <application image>```

The play server will listen on port 9000
