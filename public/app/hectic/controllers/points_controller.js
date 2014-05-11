define(["angular", "hectic"], function (angular) {
    "use strict";

    angular.module("app.controllers").controller("PointsController", [
        "$scope",
        "$routeParams",
        "CustomersService",
        "PointsService",
        function ($scope, $routeParams, CustomersService, PointsService) {
            $scope.customer = {};
            $scope.latest_transaction = {};
            $scope.history_transactions = [];
            $scope.transaction = {};
            $scope.Math = window.Math;

            if ($routeParams.id) {
                CustomersService
                    .get($routeParams.id)
                    .then(function (value) {
                        $scope.customer = value;
                    });

                PointsService
                    .findAll($routeParams.id)
                    .then(function (value) {
                        $scope.history_transactions = value;
                        if (!!value.length && value.length > 0) {
                            // The latest transaction is the first transaction on history
                            $scope.latest_transaction = value[0];
                        }
                    });
            }

            $scope.saveTransaction = function (transaction) {
                var balance
                  , currentPoints;

                if (!$routeParams.id) {
                    return;
                }
                transaction = angular.copy(transaction);
                balance = parseInt(transaction.balance);
                if (!!$scope.latest_transaction.id) {
                    currentPoints = parseInt($scope.latest_transaction.current_points);
                    if (currentPoints + balance < 0) {
                        $scope.overAttempting = true;
                        return;
                    }
                } else {
                    if (balance < 0) {
                        $scope.overAttempting = true;
                        return;
                    }
                }
                PointsService
                    .create($routeParams.id, transaction)
                    .then(function (value) {
                        if (!!value.id) {
                            $scope.latest_transaction = value;
                            $scope.history_transactions.unshift(value);
                            $scope.transaction = {};
                        }
                    });
            };
        }
    ]);
});
