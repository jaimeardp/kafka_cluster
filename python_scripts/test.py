from kafka import KafkaProducer
import json
from time import sleep

def send(bootstrap_servers, topic, message):
    """Send a message to a Kafka topic synchronously and wait for a response."""
    try:
        producer = KafkaProducer(bootstrap_servers=bootstrap_servers,
                                 request_timeout_ms=120000,
                                 linger_ms=5,
                                 security_protocol="PLAINTEXT",
                                 max_request_size=104857600,
                                 client_id="local_test_jaimeardp")

        message = prepare_message(message)
        # Send the message
        future = producer.send(topic, value=message)
        # Wait for send to complete, with optional timeout (e.g., 10 seconds)
        result = future.get(timeout=120)
        print("Message sent successfully to topic:", result.topic, "partition:", result.partition)
    except Exception as e:
        print("Failed to send message to Kafka:", e)

def prepare_message(message):

    message = json.dumps(message).encode('utf-8')

    return message

if __name__ == "__main__":

    # List of Kafka brokers. Change this to your Kafka cluster configuration.

    bootstrap_servers = ['<hostname_or_ip>:9092', '<hostname_or_ip>:9092']  

    topic = 'test'  # The Kafka topic to write to. Change this to your topic name.

    # Example message
    message = "Hello world broker!"

    # Send the message
    send(bootstrap_servers, topic, message)

    print("Message sent to Kafka topic:", topic)