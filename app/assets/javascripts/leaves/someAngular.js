var Leaves = angular.module('leaves', []);

Leaves.controller('searchController', function ($scope, $http) {
  $http.get('search/fields').then(function (newFields) {
    $scope.searchFields = newFields.data;
  });

  $scope.searchResults = [];

  $scope.search = function () {
    var fields = _.map($scope.searchFields, function (f) {
      return { name: f.name, value: f.value};
    });

    $http.post(
      'search/fetch',
      {fields: fields}
    ).then(function (results) {
      $scope.searchResults = results.data;
    });
  };
});
