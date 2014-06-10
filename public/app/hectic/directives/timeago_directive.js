define(["angular", "moment", "hectic"], function (angular, moment) {
    "use strict";

    angular.module("app.directives").directive('timeago', [
        'NotificationService',
        function (NotificationService) {
            return {
                template: '<span>{{timeAgo}}</span>',
                replace: true,
                link: function (scope, element, attrs) {
                    var updateTime = function () {
                        if (!!scope.$eval(attrs.timeago)) {
                            scope.timeAgo = moment(scope.$eval(attrs.timeago)).fromNow();
                        }
                    }
                    NotificationService.onTimeAgo(scope, updateTime); // subscribe
                    NotificationService.trigger();
                }
            }
        }
    ]);
});
