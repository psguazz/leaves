var Leaves = angular.module('leaves', [])

Leaves.controller('searchController', function ($scope, $http) {
  $scope.fields = [
    { name: 'First', value: '' },
    { name: 'Second', value: '' },
    { name: 'Third', value: '' },
    { name: 'Fourth', value: '' }
  ];

  $scope.results = [];

  $scope.search = function () {
    $scope.results = _.pluck($scope.fields, 'value');
  };
});
