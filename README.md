# Proof of concept semi-transparent proxy

This was a small experiment to see if one could create a semi-transparent proxy host, to, for example, allow previewing Hostname-sensitive sites before changing DNS. (For the hosts-file averse.)

Ultimately, probably not worth doing, but an interesting bit of openresty hackery.

# How to use it

## Build the container

    $ docker build -t hackyproxy .
    $ docker run -p 80:80 -p 443:443 hackyproxy

## Go to it

I'm going to assume 'local.docker' is your docker IP.

* Go to http://local.docker/?preview=serialized.net
* The nginx process grabs the 'preview=' argument, and proxies to it, setting that value as the proper host header
* From there on out, all responses also set a special cookie to 'remember' the preview domain.

A few of the corner cases are handled.

If the server returns a `Location`, it's updated to replace the real domain with the preview domain. That means that most redirects, including from HTTP -> HTTPS, work fine.

Also, the body of all responses is loaded in the proxy, and filtered, replacing the preview domain with the proxy host's domain. This can have some unusual side effects.

For a real use case, it would be nice to allow the host to proxy *to* to be defined by an environment variable, or other runtime tunable config.
