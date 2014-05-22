require.config({
    baseUrl: "app",
    paths: {
        async: "/components/async/lib/async",
        underscore: "/components/underscore/underscore",
        angular: "/components/angular/angular.min",
        ngResource: "/components/angular-resource/angular-resource.min",
        ngRoute: "/components/angular-route/angular-route.min",
        ngSanitize: "/components/angular-sanitize/angular-sanitize.min",
        ngUIRouter: "/components/angular-ui-router/release/angular-ui-router.min",
        moment: "/components/moment/min/moment-with-langs.min",
        jquery: "/components/jquery/dist/jquery.min",
        bootstrap: "/components/bootstrap/dist/js/bootstrap.min",
        perfectScrollbar: "/components/perfect-scrollbar/min/perfect-scrollbar-0.4.10.with-mousewheel.min",
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
        moment: {
            exports: "moment"
        },
        underscore: {
            exports: "underscore"
        },
        jquery: {
            exports: "jquery"
        },
        perfectScrollbar: {
            deps: ["jquery"]
        },
        bootstrap: {
            deps: ["jquery"]
        }
    }
});

require([
    "angular",
    "ngRoute",
    "ngSanitize",
    "ngResource",
    "ngUIRouter",
    "moment",
    "underscore",
    "jquery",
    "bootstrap",
    "perfectScrollbar",
    "async",
    "hectic"
], function (angular) {
    "use strict";

    angular.element(document).ready(function () {
        angular.bootstrap(document, ["app"]);
    });
});
