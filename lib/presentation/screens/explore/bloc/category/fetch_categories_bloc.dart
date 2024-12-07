import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ezbooking/data/models/category.dart';



class FetchCategoriesBloc extends Cubit<List<Category>> {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  bool isLoading = false;

  FetchCategoriesBloc() : super([]);

  Future<void> fetchCategories() async {
    if (isLoading) return;
    isLoading = true;

    try {
      emit([]);
      final snapshot = await firebaseFirestore
          .collection('categories')
          .orderBy('createdAt', descending: true)
          .get();

      // Parse dữ liệu từ Firestore
      final categories = snapshot.docs.map((doc) {
        return Category.fromJson({...doc.data(), 'id': doc.id});
      }).toList();

      emit(categories); // Cập nhật danh sách danh mục
    } catch (e) {
      print("Error fetching categories: $e");
      emit([]); // Emit danh sách rỗng trong trường hợp lỗi
    } finally {
      isLoading = false; // Đặt lại trạng thái
    }
  }
}

