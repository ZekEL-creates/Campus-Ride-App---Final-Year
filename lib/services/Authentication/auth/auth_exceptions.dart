//LOGIN
class InvalidCredentialAuthException implements Exception {}

//register
class InvalidEmailAuthException implements Exception {}

class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

//generic

class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}
