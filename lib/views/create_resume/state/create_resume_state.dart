import 'package:flutter_resume_template/flutter_resume_template.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resume_builder_app/local_database/local_db.dart';
import 'package:resume_builder_app/models/TemplateDataModel.dart';

  final loader= StateProvider<bool>((ref)=> false);
  final templateDataModel= StateProvider<TemplateDataModel>((ref) => TemplateDataModel());
  final templateDataIndex= StateProvider<int>((ref) => 1);

  void setIndex(WidgetRef ref)async{
    List data=await LocalDB.getTemplatesData();
    ref.read(templateDataIndex.notifier).state=data.length+1;
  }

  void setTemplateData(WidgetRef ref,TemplateDataModel data)async{
    TemplateDataModel templateData=ref.read(templateDataModel.notifier).state.copyWith(fullName: data.fullName,currentPosition: data.currentPosition,
                                                                  street:data.street,address: data.address,country: data.country,
                                                                   email: data.email,phoneNumber: data.phoneNumber,bio: data.bio);
    ref.read(templateDataModel.notifier).state= templateData;
    await LocalDB.updateTemplateData(templateData,ref);
  }

  void setTemplateEducationData(WidgetRef ref,List<Education> data)async{
    TemplateDataModel templateData= ref.read(templateDataModel.notifier).state.copyWith(educationDetails:data);
    ref.read(templateDataModel.notifier).state=templateData;
    await LocalDB.updateTemplateData(templateData,ref);
  }

  void setTemplateExperienceData(WidgetRef ref,List<ExperienceData> data)async{
    TemplateDataModel templateData= ref.read(templateDataModel.notifier).state.copyWith(experience:data);
    ref.read(templateDataModel.notifier).state=templateData;
    await LocalDB.updateTemplateData(templateData,ref);
  }

  void setSkills(WidgetRef ref,List<Language> data)async{
    TemplateDataModel templateData=ref.read(templateDataModel.notifier).state.copyWith(languages:data);
    ref.read(templateDataModel.notifier).state= templateData;
    await LocalDB.updateTemplateData(templateData,ref);
  }

  void setHobbiesDetails(WidgetRef ref,List<String> hobbies)async{
    TemplateDataModel templateData=ref.read(templateDataModel.notifier).state.copyWith(hobbies:hobbies);
    ref.read(templateDataModel.notifier).state=templateData;
    await LocalDB.updateTemplateData(templateData,ref);
  }

