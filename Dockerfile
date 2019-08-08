FROM alpine:3.8

# add packages
#RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk --update --no-cache add xrdp xvfb xfce4 thunar-volman \
faenza-icon-theme paper-gtk-theme paper-icon-theme slim xf86-input-synaptics xf86-input-mouse xf86-input-keyboard \
setxkbmap openssh util-linux dbus ttf-freefont xauth supervisor x11vnc \
util-linux dbus ttf-freefont xauth xf86-input-keyboard sudo \
dbus-x11 gtk+2.0 mesa-gl openssh-client virt-manager \
&& rm -rf /tmp/* /var/cache/apk/*

# add scripts/config
ADD etc /etc
ADD docker-entrypoint.sh /bin

# prepare user alpine
RUN addgroup alpine \
&& adduser  -G alpine -s /bin/sh -D alpine \
&& echo "alpine:alpine" | /usr/sbin/chpasswd \
&& echo "alpine    ALL=(ALL) ALL" >> /etc/sudoers
ADD alpine /home/alpine
RUN chown -R alpine:alpine /home/alpine

# prepare xrdp key
RUN xrdp-keygen xrdp auto

#EXPOSE 3389 22
EXPOSE 3389
ENTRYPOINT ["/bin/docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord","-c","/etc/supervisord.conf"]

