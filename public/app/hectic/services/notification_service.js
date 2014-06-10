define(["angular", "hectic"], function (angular) {
    "use strict";

    angular.module("app.services").service('NotificationService', [
        '$rootScope',
        function ($rootScope) {
            // events:
            var TIME_AGO_TICK = "e:timeAgo"
              , timeAgoTick = function () {
                    $rootScope.$broadcast(TIME_AGO_TICK);
                }

            // every minute, publish/$broadcast a TIME_AGO_TICK event
            setInterval(function () {
               timeAgoTick();
               $rootScope.$apply();
            }, 1000);

            // publish
            this.timeAgoTick = timeAgoTick;

            // subscribe
            this.onTimeAgo = function ($scope, handler) {
                $scope.$on(TIME_AGO_TICK, function () {
                    handler();
                });
            };

            this.trigger = function () {
                $rootScope.$broadcast(TIME_AGO_TICK);
            };
        }
    ]);
});
