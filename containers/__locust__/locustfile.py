from locust import HttpUser, task, between

HOST="http://localhost:8080"

class WebsiteUser(HttpUser):
    host = HOST
    
    @task
    def test(self):
        with self.client.get('/', name="LGTM-test", catch_response=True) as response:
            print(response)
    
    wait_time = between(1,1)