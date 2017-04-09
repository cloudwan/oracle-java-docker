Oracle Java 8 Docker
====================

This creates an image of Oracle Java 8, based upon Ubuntu 16.04.  Both the base
Java and the unlimited-strength JCE policy are installed.

Important Licensing Notes
-------------------------
Since Oracle Java may not be redistributed without permission, this base image
as well as any of its descendant images may not be uploaded to a public registry
or otherwise redistributed.

Build-time Knobs
----------------

A build requires temporary installation of the software-properties-common
package, which pulls in a large set of dependencies.  Frequent rebuilds (e.g. by
a developer) may benefit from a local HTTP proxy, which can be passed via the
`HTTP_PROXY` and `http_proxy` build-time arguments, inherited from the base
Ubuntu image.  Example::

        docker build --build-args={HTTP_PROXY,http_proxy}=http://128.66.1.2:8080

The ``ORACLE_JAVA8_INSTALL_VERBOSE=on`` build-time argument makes the main
installation script emit commands executed (via the ``-x`` shell flag), useful
for debugging the script.  Note that this introduces inconsistent build output,
as the script uses a few pipelines, and the ``-x`` outputs from the commands in
a pipeline may not be in the same order for every invocation and may even be
interleaved.

To Do/Wishlist
--------------

* Parametrize the Java version (8 for now) to install.
* Parametrize the parent image (depends on [Docker PR
  #31352](https://github.com/docker/docker/pull/31352)).
