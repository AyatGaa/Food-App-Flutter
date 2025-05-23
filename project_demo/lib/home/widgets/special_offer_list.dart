import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_demo/home/cubit/home_cubit.dart';
import 'package:project_demo/home/cubit/meal_state.dart';
import 'package:project_demo/home/widgets/special_offer_item.dart';
import '../../models/category_details.dart';
import '../../service/service_api.dart';
import '../cubit/Home_state.dart';

class MealsList extends StatefulWidget {
  const MealsList({super.key, required this.cat});

  final String cat;

  @override
  State<MealsList> createState() => _MealsListState();
}

class _MealsListState extends State<MealsList> {
  late Future<List<Meal>> meals;

  CategoryService categoryService = new CategoryService();
@override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getCategoryMealsById(widget.cat);
}
  @override
  void didUpdateWidget(covariant MealsList oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("WidgetCAt ${widget.cat}");
    context.read<HomeCubit>().getCategoryMealsById(widget.cat);
    // context.read<HomeCubit>().getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, homeState>(
      builder: (context, state) {
        switch (state.mealState) {
          case MealInitial():
            return Center(child: CircularProgressIndicator());

          case MealLoading():
            return Center(child: CircularProgressIndicator());
          case MealSuccess():
            final list = (state.mealState as MealSuccess).mealList;
            return SizedBox(
              height: 135.h,
width: 330.w,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: list.length ?? 0,
                separatorBuilder: (context, index) => SizedBox(width: 12.w),
                itemBuilder: (context, index) {
                  return MealItem(category: list[index]);
                },
              ),
            );
          case MealError():
            final message = (state.categoryState as MealError).message;

            return Center(child: Text("Error: ${message}"));
        }

        // if (snapshot.hasData) {
        //
        // } else if (snapshot.hasError) {
        //   return Center(child: Text("Error: ${snapshot.error}"));
        // } else {
        //   return Center(child: CircularProgressIndicator());
        // }
      },
    );
  }
}
