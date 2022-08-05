
#include <assert.h>
#include <errno.h>
#include <poll.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/ip.h>

//#define DEBUG

#ifdef DEBUG
#define DEBUG_PRINTF(...)  fprintf(stderr, __VA_ARGS__)
#else
#define DEBUG_PRINTF(...)
#endif

#ifdef __cplusplus
extern "C" {
#endif

int socket_open(int port) {
    assert(port > 0);

    DEBUG_PRINTF("%s\n", __PRETTY_FUNCTION__);

    int ret;
    int s;
    struct sockaddr_in sockaddr;

    s = socket(AF_INET, SOCK_STREAM, 0);
    if (s < 0) {
	perror("socket() failed");
	abort();
    }

    sockaddr.sin_family = AF_INET;
    sockaddr.sin_port = htons(port);
    sockaddr.sin_addr.s_addr = htonl(INADDR_ANY);

    ret = bind(s, (struct sockaddr *)&sockaddr, sizeof(sockaddr));
    if (ret < 0) {
	perror("bind() failed");
	abort();
    }

    ret = listen(s, 1);
    if (ret < 0) {
	perror("listen() failed");
	abort();
    }

    return s;
}

int socket_accept(int fd) {
    assert(fd >= 0);

    DEBUG_PRINTF("%s\n", __PRETTY_FUNCTION__);

    struct pollfd fds[1];
    fds[0].fd = fd;
    fds[0].events = POLLIN;

    int ret = poll(fds, 1, 0);
    if (ret < 0) {
	perror("poll() failed");
	abort();
    }
    if (ret == 0)
	return -1;

    return accept(fd, NULL, 0);
}

int socket_putchar(int fd, int c) {
    assert(fd >= 0);

    DEBUG_PRINTF("%s\n", __PRETTY_FUNCTION__);

    int ret;

    ret = send(fd, &c, 1, 0);
    if (ret < 0) {
	perror("send() failed");
	abort();
    }

    return ret;
}

int socket_getchar(int fd) {
    assert(fd >= 0);

    int ret;
    unsigned char c;

    ret = recv(fd, &c, 1, MSG_DONTWAIT);
    if (ret < 0 && errno != EAGAIN && errno != EWOULDBLOCK) {
	perror("recv() failed");
	abort();
    }

    return ret > 0 ? c : -1;
}

int socket_send32(int fd, uint32_t data) {
    assert(fd >= 0);

    DEBUG_PRINTF("%s\n", __PRETTY_FUNCTION__);

    int ret;

    ret = send(fd, &data, sizeof(data), 0);
    if (ret < 0) {
	perror("send() failed");
	abort();
    }

    return ret;
}

#ifdef __cplusplus
}
#endif
