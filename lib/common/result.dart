sealed class Result<T> {
  factory Result.success(T data) = Success<T>;
  factory Result.error(String e) = Error<T>;
}

class Success<T> implements Result<T> {
  final T data;
  const Success(this.data);
}

class Error<T> implements Result<T> {
  final String error;
  const Error(this.error);
}