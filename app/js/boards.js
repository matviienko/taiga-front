function initBoard(userstories) {
    // const sizes = {
    //     swimline: 180,
    // };

    function swimlineObserver() {
        const swimlane = document.querySelector('.kanban-table-swimlane');

        const options = {
            root: swimlane,
            rootMargin: '100px',
            threshold: 0
        }

        const callback = function(entries) {
            entries.forEach(entry => {
                const body = entry.target.querySelector('.kanban-table-body');

                if (!entry.isIntersecting) {
                    const height = body.getBoundingClientRect().height;
                    body.style.minHeight = `${height}px`;
                } else {
                    requestAnimationFrame(() => {
                        body.removeAttribute('style');
                    });
                }

                eventsCallback('SWIMLINE.VISIBILITY', {
                    id: Number(entry.target.dataset.swimline),
                    visible: entry.isIntersecting
                });
            });
        };

        return new IntersectionObserver(callback, options);
    }

    function kanbanColumnObserver() {
        const kanbanTable = document.querySelector('.kanban-table');

        const options = {
            root: kanbanTable,
            rootMargin: '100px',
            threshold: 0
        }

        const callback = function(entries) {
            entries.forEach(entry => {
                const id = `${Number(entry.target.dataset.swimline)}-${Number(entry.target.dataset.statusId)}`;

                if (!entry.isIntersecting) {
                    const height = entry.target.getBoundingClientRect().height;
                    entry.target.style.minHeight = `${height}px`;
                } else {
                    requestAnimationFrame(() => {
                        entry.target.removeAttribute('style');
                    });
                }

                eventsCallback('COLUMN.VISIBILITY', {
                    id,
                    visible: entry.isIntersecting
                });
            });
        };

        return new IntersectionObserver(callback, options);
    }

    let eventsCallback = () => {};

    // swimlane
    const swimlaneObserver = swimlineObserver();

    // status column
    const statusColumnObserver = kanbanColumnObserver();

    return {
        events: (cb) => {
            eventsCallback = cb;
        },
        start: () => {
/*             const swimlineTargets = document.querySelectorAll('.kanban-swimline');

            swimlineTargets.forEach((target) => {
                swimlaneObserver.observe(target);
            }); */

            // kanban-table
            const columnTargets = document.querySelectorAll('.taskboard-column');
            console.log('do', columnTargets);
            columnTargets.forEach((target) => {
                statusColumnObserver.observe(target);
            });
        }
    }
}


/*
            const targets = document.querySelectorAll('.kanban-swimline');

            const swimlane = document.querySelector('.kanban-table-swimlane');
            const swimlaneSize = swimlane.getBoundingClientRect();
            console.log(swimlaneSize)
            const sizeAcc = 0;

            swimlaneSize.height / sizes.swimline

            targets.filter(() => {
                if (sizeAcc < swimlaneSize.height) {
                    sizeAcc
                    return true;
                }

                return false;
            });

            console.log('init', swimlane.scrollTop);*/
