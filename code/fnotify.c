/*
 * file_access_notify.c - notify about file access
 */

#include <linux/fcntl.h>
#include <stdio.h>
#include <sys/fanotify.h>

int main(int arg, char **argv) {

    struct fanotify_event_metadata ev;

    int fa = fanotify_init(FAN_CLASS_NOTIF,
	O_RDONLY | O_LARGEFILE);

    if (fa >= 0) {
	int m = fanotify_mark(fa,
	    FAN_MARK_ADD,
	    FAN_OPEN | FAN_EVENT_ON_CHILD,
	    AT_FDCWD,
	    argv[1]);
	if (m) {
	    perror("error with 'fanotify_mark()'");
	    return 2;
	}
	while (read(fa, &ev, sizeof(ev))
	      == sizeof(ev)) {
	    printf("PID: %d, FD: %d, M: 0x%02llX\n",
		ev.pid, ev.fd, ev.mask);
	}
    }
    else {
	perror("error with 'fanotify_init()'");
	return 1;
    }
    return 0;

}
