# CEM1.0-Java-MiNiFi

## Docker Instance for Java MiNiFi which connects to Edge Flow Manager UI

This docker instance will build a minifi instance

1.  Git Clone
2.  Build a docker image
  * `docker build --no-cache -t java-minifi .` <br><br>
To supply class name as argument
  * `docker build --build-arg MINIFI_AGENT_CLASS=sunmanClass --no-cache -t minifi-java .`
3.  Run the image
  * `docker run java-minifi`
<br><br>
### Add Nars<br>
Place Nars in a shared location (like s3) and update config.sh.  At run time nars will be pulled into the lib directory
