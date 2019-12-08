FROM continuumio/miniconda3 AS conda

FROM ubuntu:16.04 AS dev-base
COPY --from=conda /opt/conda/ /opt/conda/

LABEL maintainer="junki.ohmura@gmail.com"

RUN apt-get update -y && \
    apt-get install -y software-properties-common && \
    apt-add-repository -y ppa:neovim-ppa/stable && \
    apt-get update -y && \
    apt-get install -y \
    locales \
    curl \
    wget \
    zip \
    git \
    tmux \
    zsh \
    neovim

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

SHELL ["/usr/bin/zsh", "--login", "-c"]

ADD . /root/.config
ADD . /work
WORKDIR /work

RUN curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh && \
    bash ./installer.sh ~/.config/dein

ADD . /f
RUN curl -L -o dotfiles.zip https://github.com/jojonki/dotfiles/archive/master.zip && \
    unzip dotfiles.zip
RUN cp -r ./dotfiles-master/nvim ~/.config && \
    cp -r ./dotfiles-master/dein ~/.config && \
    cp -r ./dotfiles-master/.zshrc ~/ && \
    cp -r ./dotfiles-master/.tmux.conf ~/ && \
    cp -r ./dotfiles-master/.pylintrc ~/

#RUN echo "export LC_ALL=en_US.UTF-8" >> ~/.zshrc
# Set the locale

#RUN echo "export PATH=\"/opt/conda/bin:$PATH\"" >> ~/.zshrc && \
ENV PATH="/opt/conda/bin:${PATH}"
RUN . ~/.zshrc && \
    conda create -n neovim2 python=2.7.17 && \
    conda create -n neovim3 python=3.7.5 && \
    . activate neovim2 && \
    pip install neovim && \
    . activate neovim3 && \
    pip install neovim


RUN curl -L git.io/nodebrew | perl - setup && \
    $HOME/.nodebrew/current/bin/nodebrew install 12.13.1 && \
    $HOME/.nodebrew/current/bin/nodebrew use 12.13.1
# echo "export PATH=\"$HOME/.nodebrew/current/bin:$PATH\"" >> ~/.zshrc
ENV PATH="/${HOME}/.nodebrew/current/bin:${PATH}"

#SHELL ["/usr/bin/zsh", "-c"]
#
#RUN . ~/.zshrc

RUN echo "let g:python_host_prog =  '/opt/conda/envs/neovim2/bin/python'" >> ~/.config/nvim/init.vim && \ 
    echo "let g:python3_host_prog = '/opt/conda/envs/neovim3/bin/python'" >> ~/.config/nvim/init.vim && \
    echo "let g:coc_node_path = '$HOME/.nodebrew/current/bin/node'" >> ~/.config/nvim/init.vim
#
#CMD ["/usr/bin/zsh","-l"]
RUN nvim +'call dein#update()' +qall
#RUN yes | . ~/.zshrc

#FROM python:2.7
#ADD . /code
#WORKDIR /code
#RUN pip install -r requirements.txt
#CMD python app.py

