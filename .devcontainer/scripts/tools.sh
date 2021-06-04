#!/bin/bash
# install tools for container standup
echo "cwd: $(pwd)"
echo "---getting tools---"
# complete
sudo apt-get install bash-completion -y
# pre-commit
pre-commit install
# kubectl
echo "alias k=kubectl" >> /home/f5-devops/.bashrc
echo 'source <(kubectl completion bash)' >> /home/f5-devops/.bashrc
echo "source <(kubectl completion bash | sed 's|__start_kubectl kubectl|__start_kubectl k|g')" >> /home/f5-devops/.bashrc
echo "---tools done---"
exit
