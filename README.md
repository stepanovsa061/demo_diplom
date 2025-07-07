# Дипломный практикум в Yandex.Cloud
- Цели:
- Этапы выполнения:
  1. Создание облачной инфраструктуры
  2. Создание Kubernetes кластера
  3. Создание тестового приложения
  4. Подготовка cистемы мониторинга и деплой приложения
  5. Установка и настройка CI/CD
- Что необходимо для сдачи задания?
- Как правильно задавать вопросы дипломному руководителю?

# Цели:
1. Подготовить облачную инфраструктуру на базе облачного провайдера Яндекс.Облако.
2. Запустить и сконфигурировать Kubernetes кластер.
3. Установить и настроить систему мониторинга.
4. Настроить и автоматизировать сборку тестового приложения с использованием Docker-контейнеров.
5. Настроить CI для автоматической сборки и тестирования.
6. Настроить CD для автоматического развёртывания приложения.

# Этапы выполнения:

# Создание облачной инфраструктуры
Для начала необходимо подготовить облачную инфраструктуру в ЯО при помощи Terraform.

Особенности выполнения:

> Бюджет купона ограничен, что следует иметь в виду при проектировании инфраструктуры и использовании ресурсов; Для облачного k8s используйте региональный мастер(неотказоустойчивый). Для self-hosted k8s минимизируйте ресурсы ВМ и долю ЦПУ. В обоих вариантах используйте прерываемые ВМ для worker nodes.

Предварительная подготовка к установке и запуску Kubernetes кластера.

1. Создайте сервисный аккаунт, который будет в дальнейшем использоваться Terraform для работы с инфраструктурой с необходимыми и достаточными правами. Не стоит использовать права суперпользователя
2. Подготовьте backend для Terraform:
а. Рекомендуемый вариант: S3 bucket в созданном ЯО аккаунте(создание бакета через TF)
б. Альтернативный вариант: Terraform Cloud
3. Создайте VPC с подсетями в разных зонах доступности.
4. Убедитесь, что теперь вы можете выполнить команды terraform destroy и terraform apply без дополнительных ручных действий.
5. В случае использования Terraform Cloud в качестве backend убедитесь, что применение изменений успешно проходит, используя web-интерфейс Terraform cloud.

Ожидаемые результаты:

Terraform сконфигурирован и создание инфраструктуры посредством Terraform возможно без дополнительных ручных действий.
Полученная конфигурация инфраструктуры является предварительной, поэтому в ходе дальнейшего выполнения задания возможны изменения.

# Решение

![виртуальные машины YO](https://github.com/user-attachments/assets/9a9e1ca0-8d6e-4b2f-8ff9-ce0d21c4cda9)

![Сабнет](https://github.com/user-attachments/assets/3f69fddf-8e30-4ab6-ba68-486a712ffe81)

![Сервисный аккаунт](https://github.com/user-attachments/assets/8c43913b-cd1c-43e8-a291-3a04c5821504)

![Бакет](https://github.com/user-attachments/assets/7d0fcb66-9019-428a-8676-dbea35057c7e)

![2](https://github.com/user-attachments/assets/c737ce93-6adc-494e-ace9-44bd057aefcb)


# Создание Kubernetes кластера
На этом этапе необходимо создать Kubernetes кластер на базе предварительно созданной инфраструктуры. Требуется обеспечить доступ к ресурсам из Интернета.

Это можно сделать двумя способами:

1. Рекомендуемый вариант: самостоятельная установка Kubernetes кластера.
а. При помощи Terraform подготовить как минимум 3 виртуальных машины Compute Cloud для создания Kubernetes-кластера. Тип виртуальной машины следует выбрать самостоятельно с учётом требовании к производительности и стоимости. Если в дальнейшем поймете, что необходимо сменить тип инстанса, используйте Terraform для внесения изменений.
б. Подготовить ansible конфигурации, можно воспользоваться, например Kubespray
в. Задеплоить Kubernetes на подготовленные ранее инстансы, в случае нехватки каких-либо ресурсов вы всегда можете создать их при помощи Terraform.

2. Альтернативный вариант: воспользуйтесь сервисом Yandex Managed Service for Kubernetes
а. С помощью terraform resource для kubernetes создать региональный мастер kubernetes с размещением нод в разных 3 подсетях
б. С помощью terraform resource для kubernetes node group

Ожидаемый результат:

1. Работоспособный Kubernetes кластер.
2. В файле ~/.kube/config находятся данные для доступа к кластеру.
3. Команда kubectl get pods --all-namespaces отрабатывает без ошибок.

# Решение
```
step@step-diplom:~$ kubectl get pods --all-namespaces
NAMESPACE     NAME                                       READY   STATUS    RESTARTS        AGE
kube-system   calico-kube-controllers-85c5d47cb8-2wrk9   1/1     Running   1 (10m ago)     7h38m
kube-system   calico-node-6l8gv                          1/1     Running   1 (10m ago)     7h39m
kube-system   calico-node-bwg9t                          1/1     Running   1 (9m45s ago)   7h39m
kube-system   calico-node-lzkq7                          1/1     Running   1 (10m ago)     7h39m
kube-system   coredns-84668b4497-cd6sd                   1/1     Running   1 (9m45s ago)   7h38m
kube-system   coredns-84668b4497-p8kbx                   1/1     Running   1 (10m ago)     7h38m
kube-system   dns-autoscaler-56cb45595c-wlclq            1/1     Running   1 (10m ago)     7h38m
kube-system   kube-apiserver-master                      1/1     Running   2 (9m45s ago)   7h41m
kube-system   kube-controller-manager-master             1/1     Running   3 (9m45s ago)   7h41m
kube-system   kube-proxy-57nv9                           1/1     Running   1 (9m45s ago)   7h40m
kube-system   kube-proxy-h5j92                           1/1     Running   1 (10m ago)     7h40m
kube-system   kube-proxy-rzngj                           1/1     Running   1 (10m ago)     7h40m
kube-system   kube-scheduler-master                      1/1     Running   3 (9m45s ago)   7h41m
kube-system   nginx-proxy-worker-1                       1/1     Running   1 (10m ago)     7h40m
kube-system   nginx-proxy-worker-2                       1/1     Running   1 (10m ago)     7h40m
kube-system   nodelocaldns-c6dzz                         1/1     Running   4 (8m33s ago)   7h38m
kube-system   nodelocaldns-kr5mf                         1/1     Running   1 (10m ago)     7h38m
kube-system   nodelocaldns-pzwfp                         1/1     Running   1 (10m ago)     7h38m
```
```
step@step-diplom:~$ kubectl get nodes
NAME       STATUS   ROLES           AGE     VERSION
master     Ready    control-plane   7h42m   v1.33.2
worker-1   Ready    <none>          7h41m   v1.33.2
worker-2   Ready    <none>          7h41m   v1.33.2
```

# Создание тестового приложения
Для перехода к следующему этапу необходимо подготовить тестовое приложение, эмулирующее основное приложение разрабатываемое вашей компанией.

Способ подготовки:

1. Рекомендуемый вариант:
а. Создайте отдельный git репозиторий с простым nginx конфигом, который будет отдавать статические данные.
б. Подготовьте Dockerfile для создания образа приложения.

2. Альтернативный вариант:
а. Используйте любой другой код, главное, чтобы был самостоятельно создан Dockerfile.

Ожидаемый результат:

1. Git репозиторий с тестовым приложением и Dockerfile.
2. Регистри с собранным docker image. В качестве регистри может быть DockerHub или Yandex Container Registry, созданный также с помощью terraform.

# Решение
Dockerfile:

```
FROM nginx:latest

# Configuration
COPY conf /etc/nginx
# Content
COPY content /usr/share/nginx/html

#Health Check
HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD curl -f http://localhost/ || exit 1

EXPOSE 80
```
Также создаём файл ~/test_app/conf/nginx.conf с конфигурацией:
```
user nginx;
worker_processes 1;
error_log /var/log/nginx/error.log warn;

events {
    worker_connections 1024;
    multi_accept on;
}

http {
    server {
        listen   80;

        location / {
            gzip off;
            root /usr/share/nginx/html/;
            index index.html;
        }
    }
    keepalive_timeout  60;
```
Cоздаём статическую страницу приложения:
```
<!DOCTYPE html>
<html lang="ru">

<head>
    <meta charset="utf-8" name="viewport" content="width=device-width, initial-scale=1" />
    <title>Diplom of Stepanov Sergey</title>
</head>

<body>
    <h2 style="margin-top: 150px; text-align: center;">Student Netology</h2>
</body>

</html>
```

```
step@step-diplom:~/test_app_diplom$ docker push stepserg/nginx-diplom
The push refers to repository [docker.io/stepserg/nginx-diplom]
57145b94ac6a: Pushed
c99a3a7b2cc7: Pushed
cd38dca3d982: Pushed
d35594dd7e6d: Pushed
126eaee18409: Pushed
6380429cac56: Pushed
13fcb2d303e8: Pushed
151f9feea563: Pushed
7fb72a7d1a8e: Pushed
latest: digest: sha256:9317a87d54f0561a9dafd379a83e234b8a78a57026e52b3db68ca2e6649d4103 size: 2192
step@step-diplom:~/test_app_diplom$
```

![docker_hub](https://github.com/user-attachments/assets/1eead599-101a-43a4-af81-44547aaed13f)

![4](https://github.com/user-attachments/assets/dd39ad13-791a-4224-81e0-637b55186c14)

```
docker pull stepserg/nginx-app
```

Для размещения приложения выбран GitHub: https://github.com/stepanovsa061/test_app_diplom

# Подготовка cистемы мониторинга и деплой приложения
Уже должны быть готовы конфигурации для автоматического создания облачной инфраструктуры и поднятия Kubernetes кластера.
Теперь необходимо подготовить конфигурационные файлы для настройки нашего Kubernetes кластера.

Цель:

1. Задеплоить в кластер prometheus, grafana, alertmanager, экспортер основных метрик Kubernetes.
2. Задеплоить тестовое приложение, например, nginx сервер отдающий статическую страницу.
Способ выполнения:

1. Воспользоваться пакетом kube-prometheus, который уже включает в себя Kubernetes оператор для grafana, prometheus, alertmanager и node_exporter.
2. Альтернативный вариант - использовать набор helm чартов от bitnami.

# Решение

Создадим namespace monitoring
```
step@step-diplom:~/demo_diplom$ kubectl create namespace monitoring
namespace/monitoring created
step@step-diplom:~/demo_diplom$ kubectl get ns
NAME              STATUS   AGE
default           Active   22h
kube-node-lease   Active   22h
kube-public       Active   22h
kube-system       Active   22h
monitoring        Active   16s
step@step-diplom:~/demo_diplom$
```

Подключим репозиторий с promutheus:
```
step@step-diplom:~/demo_diplom$ helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
"prometheus-community" has been added to your repositories
step@step-diplom:~/demo_diplom$ helm repo update
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "prometheus-community" chart repository
Update Complete. ⎈Happy Helming!⎈
step@step-diplom:~/demo_diplom$
```

helm repo update
```
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "prometheus-community" chart repository
Update Complete. ⎈Happy Helming!⎈
```

Задеплоим систему мониторинга:
```
step@step-diplom:~/demo_diplom$ helm install stable prometheus-community/kube-prometheus-stack --namespace=monitoring
NAME: stable
LAST DEPLOYED: Wed Jun 25 22:08:46 2025
NAMESPACE: monitoring
STATUS: deployed
REVISION: 1
NOTES:
kube-prometheus-stack has been installed. Check its status by running:
  kubectl --namespace monitoring get pods -l "release=stable"

Get Grafana 'admin' user password by running:

  kubectl --namespace monitoring get secrets stable-grafana -o jsonpath="{.data.admin-password}" | base64 -d ; echo

Access Grafana local instance:

  export POD_NAME=$(kubectl --namespace monitoring get pod -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=stable" -oname)
  kubectl --namespace monitoring port-forward $POD_NAME 3000

Visit https://github.com/prometheus-operator/kube-prometheus for instructions on how to create & configure Alertmanager and Prometheus instances using the Operator.
step@step-diplom:~/demo_diplom$

```
Проверим состояние мониторинга: kubectl get all -n monitoring

![7](https://github.com/user-attachments/assets/4b7b9b97-6ae9-41e5-8991-4882ff362546)


```
step@step-diplom:~/demo_diplom$ kubectl apply -f deployment.yaml
daemonset.apps/myapp created
service/myapp-service created
```
```
step@step-diplom:~/demo_diplom$ kubectl get svc -n monitoring
NAME                                      TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE
alertmanager-operated                     ClusterIP   None            <none>        9093/TCP,9094/TCP,9094/UDP   5d2h
myapp-service                             NodePort    10.233.13.216   <none>        80:30080/TCP                 56s
prometheus-monitoring                     NodePort    10.233.63.156   <none>        8080:30500/TCP               65m
prometheus-operated                       ClusterIP   None            <none>        9090/TCP                     5d2h
stable-grafana                            ClusterIP   10.233.59.52    <none>        80/TCP                       5d2h
stable-kube-prometheus-sta-alertmanager   ClusterIP   10.233.58.226   <none>        9093/TCP,8080/TCP            5d2h
stable-kube-prometheus-sta-operator       ClusterIP   10.233.6.166    <none>        443/TCP                      5d2h
stable-kube-prometheus-sta-prometheus     ClusterIP   10.233.11.98    <none>        9090/TCP,8080/TCP            5d2h
stable-kube-state-metrics                 ClusterIP   10.233.15.229   <none>        8080/TCP                     5d2h
stable-prometheus-node-exporter           ClusterIP   10.233.3.130    <none>        9100/TCP                     5d2h
```

![29 06 grafana](https://github.com/user-attachments/assets/2815daf1-58eb-4c96-bde1-9abbe2638b01)

![prometheus](https://github.com/user-attachments/assets/29e5942e-dbff-4b80-9e10-d11c013e9621)

![30 06 deployment](https://github.com/user-attachments/assets/fd57a6b2-63cf-4927-bb51-07ecac3319fb)

# Деплой инфраструктуры в terraform pipeline
1. Если на первом этапе вы не воспользовались Terraform Cloud, то задеплойте и настройте в кластере atlantis для отслеживания изменений инфраструктуры. Альтернативный вариант 3 задания: вместо Terraform Cloud или atlantis настройте на автоматический запуск и применение конфигурации terraform из вашего git-репозитория в выбранной вами CI-CD системе при любом комите в main ветку. Предоставьте скриншоты работы пайплайна из CI/CD системы.

Ожидаемый результат:

1. Git репозиторий с конфигурационными файлами для настройки Kubernetes.
2. Http доступ на 80 порту к web интерфейсу grafana.
3. Дашборды в grafana отображающие состояние Kubernetes кластера.
4. Http доступ на 80 порту к тестовому приложению.
5. Atlantis или terraform cloud или ci/cd-terraform

# Решение

Для деплоя приложения сначала создадим манифест deployment.yaml.
```
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: myapp
  namespace: monitoring
  labels:
    app: myapp
spec:
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: myapp
        image: stepserg/nginx-diplom:latest
      restartPolicy: Always

---

apiVersion: v1
kind: Service
metadata:
  name: myapp-service
  namespace: monitoring
spec:
  selector:
    app: myapp
  type: NodePort
  ports:
  - name: http
    protocol: TCP
    port: 80
    targetPort: 80
    nodePort: 30080

```

```
step@step-diplom:~/demo_diplom$ kubectl apply -f deployment.yaml
daemonset.apps/myapp created
service/myapp-service created
```

# Установка и настройка CI/CD
Осталось настроить ci/cd систему для автоматической сборки docker image и деплоя приложения при изменении кода.

Цель:

1. Автоматическая сборка docker образа при коммите в репозиторий с тестовым приложением.
2. Автоматический деплой нового docker образа.

Можно использовать teamcity, jenkins, GitLab CI или GitHub Actions.

Ожидаемый результат:

1. Интерфейс ci/cd сервиса доступен по http.
2. При любом коммите в репозиторие с тестовым приложением происходит сборка и отправка в регистр Docker образа.
3. При создании тега (например, v1.0.0) происходит сборка и отправка с соответствующим label в регистри, а также деплой соответствующего Docker образа в кластер Kubernetes.

# Решение

Workflow:
```
name: ci

on:
  push:
    branches: [main]

env:
  IMAGE_TAG: stepserg/nginx-app

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Login to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

      - name: Check Docker login
        run: |
          echo "Checking Docker login..."
          docker login --username "${{ secrets.DOCKERHUB_USERNAME }}" --password "${{ secrets.DOCKERHUB_TOKEN }}"

      - name: Setup Docker BuildX
        uses: docker/setup-buildx-action@v3

      - name: Build and Push Docker Image
        uses: docker/build-push-action@v3
        with:
          context: .
          file: ./Dockerfile
          push: true
          tags: ${{ env.IMAGE_TAG }}:${{ github.sha }}
```

![secrets](https://github.com/user-attachments/assets/e8f8e3ae-5657-4bf6-bf87-e923218dc5d3)

![actions](https://github.com/user-attachments/assets/bb201c63-68f5-4b9b-93d2-9c5b316791b8)


# Что необходимо для сдачи задания?
1. Репозиторий с конфигурационными файлами Terraform и готовность продемонстрировать создание всех ресурсов с нуля.
2. Пример pull request с комментариями созданными atlantis'ом или снимки экрана из Terraform Cloud или вашего CI-CD-terraform pipeline.
3. Репозиторий с конфигурацией ansible, если был выбран способ создания Kubernetes кластера при помощи ansible.
4. Репозиторий с Dockerfile тестового приложения и ссылка на собранный docker image.
5. Репозиторий с конфигурацией Kubernetes кластера.
6. Ссылка на тестовое приложение и веб интерфейс Grafana с данными доступа.
7. Все репозитории рекомендуется хранить на одном ресурсе (github, gitlab)
