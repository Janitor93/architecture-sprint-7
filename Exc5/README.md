# Запуск

```
sh create_services.sh
kubectl apply -f non-admin-api-allow.yml
kubectl apply -f admin-api-allow.yml
```

# Проверка

```
kubectl exec -it front-end-app -- curl http://back-end-api-app
```
