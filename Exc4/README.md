# Kubernetes RBAC

Первым делом выполняем команды:

```
kubectl apply -f roles.yml
kubectl apply -f roles_binding.yml
```

Создаем пользователей при помощи скрипта, который попросит ввесит имя пользователя и выбрать ему роль:

```
sh create_user.sh
```

Далее можно отразить список доступных действий для пользователя:

```
sh check_permissions.sh
```

Либо сменить контекст и попробовать отразить список подов или создать новый:

```
kubectl config use-context ${username}-context
kubectl get pods
kubectl run nginx --image=nginx --port=80
```

При удалении пользователей необходимо так же удалить созданные для них папки для последующей корректной работы.

