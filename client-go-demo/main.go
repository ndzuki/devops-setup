package main

import (
	"context"
	"flag"
	"fmt"
	"path/filepath"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/labels"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/tools/clientcmd"
	"k8s.io/client-go/util/homedir"
)

func main() {
	var kubeconfig *string
	if home := homedir.HomeDir(); home != "" {
		kubeconfig = flag.String(
			"kubeconfig",
			filepath.Join(home, ".kube", "config"),
			"(optional) absolute path to the kubeconfig file",
		)
	} else {
		kubeconfig = flag.String("kubeconfig", "", "absolute path to the kubeconfig file")
	}
	flag.Parse()

	// use the current context in kubeconfig
	config, err := clientcmd.BuildConfigFromFlags("", *kubeconfig)
	if err != nil {
		panic(err.Error())
	}

	// create the clientset
	clientset, err := kubernetes.NewForConfig(config)
	if err != nil {
		panic(err.Error())
	}

	namespace := "test"
	svc := "imx-gateway"
	svcCanary := svc + "-canary"

	service, err := clientset.CoreV1().
		Services(namespace).
		Get(context.TODO(), svcCanary, metav1.GetOptions{})
	if err != nil {
		fmt.Println(err.Error())
	}
	fmt.Printf("service: %v\n", service.GetName())

	// labels.Parser
	set := labels.Set(service.Spec.Selector)
	as := set.AsSelector().String()

	if pods, err := clientset.CoreV1().Pods(namespace).List(context.TODO(), metav1.ListOptions{LabelSelector: as}); err != nil {
		fmt.Printf("List Pods of service[%s] error:%v", service.GetName(), err)
	} else {
		for _, v := range pods.Items {
			fmt.Printf("pod: %v\nstatus: %v", v.GetName(), v.Status.Phase)
		}
	}
}
