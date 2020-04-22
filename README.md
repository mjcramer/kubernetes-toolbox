# docker-images
A collection of docker images that I use for stuff

```shell script
docker run -it kubernetes-toolbox mjcramer/kubernetes-toolbox:latest
```

### Reading Kafka topic and decoding Avro
```
# Create the pod that will run the container with the Kafka tools
kubectl -n <namespace> apply -f pod.yaml
# Get a bash shell into the container
kubectl exec -n <namespace> -it kafka-avro-tools -- /bin/bash
# Use the tools, for instance to read avro messages, print as JSON.
kafkacat -C -b <broker-cluster-IP>:9092 -t <topic> -q -u -D "" -f %s | java -jar /avro-tools/avro-tools-1.8.2.jar fragtojson --schema-file /schemas/<schema-file> - | jq .
```



