
import 'package:here4u/models/user_entity.dart';
import 'package:here4u/mvvm/data/repository/user_repository.dart';

class UserService {
  final UserRepository _repository = UserRepository();

  Future<void> registerUser(UserEntity user) => _repository.createUser(user);

  Future<UserEntity?> fetchUser(String id) => _repository.getUser(id);

  // Add more business logic as needed
}