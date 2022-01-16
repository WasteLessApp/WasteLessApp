import firebase_admin
from firebase_admin import credentials
from firebase_admin import messaging

cred = credentials.Certificate('service-account-file.json')
firebase_admin.initialize_app(cred)
# The topic name can be optionally prefixed with "/topics/".
topic = 'fcm_test'

# See documentation on defining a message payload.
message = messaging.Message(
    data={
        'score': '850',
        'time': '2:45',
    },
    topic=topic,
)

# Send a message to the devices subscribed to the provided topic.
response = messaging.send(message)
# Response is a message ID string.
print('Successfully sent message:', response)