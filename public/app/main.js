require.config({
    baseUrl: "app",
    paths: {
        underscore: "/components/underscore/underscore",
        angular: "/components/angular/angular.min",
        ngResource: "/components/angular-resource/angular-resource.min",
        ngRoute: "/components/angular-route/angular-route.min",
        ngSanitize: "/components/angular-sanitize/angular-sanitize.min",
        ngUIRouter: "/components/angular-ui-router/release/angular-ui-router.min",
        jquery: "/components/jquery/dist/jquery.min",
        bootstrap: "/components/bootstrap/dist/js/bootstrap.min"
    },
    packages: [
        {
            name: "hectic",
            location: "/app/hectic",
            main: "main"
        }
    ],
    shim: {
        angular: {
            exports: "angular"
        },
        ngResource: {
            deps: ["angular"]
        },
        ngRoute: {
            deps: ["angular"]
        },
        ngSanitize: {
            deps: ["angular"]
        },
        ngUIRouter: {
            deps: ["angular"]
        },
        underscore: {
            exports: "underscore"
        }
    }
});

require([
    "angular",
    "ngRoute",
    "ngSanitize",
    "ngResource",
    "ngUIRouter",
    "underscore",
    "jquery",
    "bootstrap",
    "hectic"
], function (angular) {
    "use strict";

    angular.element(document).ready(function () {
        angular.bootstrap(document, ["app"]);
    });
});
