#!/bin/bash
set -ex
kind delete clusters capi-management-gcp
kubectl ctx -d kind-capi-management-gcp