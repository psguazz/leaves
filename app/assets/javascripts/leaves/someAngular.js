var Leaves = angular.module('leaves', [])

Leaves.controller('searchController', function ($scope, $http) {
  $http.get('search/fields').then(function (newFields) {
    $scope.fields = newFields.data;
  });

  $scope.results = [];

  $scope.search = function () {
    $scope.results = _.pluck($scope.fields, 'value');
  };
});
