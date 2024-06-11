import 'package:dictionary_api/dictionary_model.dart';
import 'package:dictionary_api/services.dart';
import 'package:flutter/material.dart';

void main() => runApp(const DictionaryHomePage());

class DictionaryHomePage extends StatefulWidget {
  const DictionaryHomePage({super.key});

  @override
  State<DictionaryHomePage> createState() => _DictionaryHomePageState();
}

class _DictionaryHomePageState extends State<DictionaryHomePage> {
  DictionaryModel? dictionaryModel;
  bool isLoading = false;
  String noDataFound = "Bắt đầu tìm kiếm";

  searchContain(String word) async {
    setState(() {
      isLoading = true;
    });
    try {
      dictionaryModel = await APIServices.fetchData(word);
    } catch (e) {
      dictionaryModel = null;
      noDataFound = "Không có dữ liệu từ";
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dictionary With API'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              SearchBar(
                hintText: 'Tìm từ',
                onSubmitted: (value) {
                  searchContain(value);
                },
              ),
              const SizedBox(
                height: 10,
              ),
              if (isLoading)
                const LinearProgressIndicator()
              else if (dictionaryModel != null)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        dictionaryModel!.word,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.blue,
                        ),
                      ),
                      Text(
                        dictionaryModel!.phonetics.isNotEmpty
                            ? dictionaryModel!.phonetics[0].text ?? ""
                            : "",
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: dictionaryModel!.meanings.length,
                          itemBuilder: (context, index) {
                            return showMeaning(
                                dictionaryModel!.meanings[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                )
              else
                Center(
                  child: Text(
                    noDataFound,
                    style: const TextStyle(
                      fontSize: 22,
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  showMeaning(Meaning meaning) {
    String wordDefinition = "";
    for (var element in meaning.definitions) {
      int index = meaning.definitions.indexOf(element);
      wordDefinition += "\n${index + 1}.${element.definition}\n";
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                meaning.partOfSpeech,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Nghĩa : ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              Text(
                wordDefinition,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1,
                ),
              ),
              wordRelation("Từ đồng nghĩa", meaning.synonyms),
              wordRelation("Từ trái nghĩa", meaning.antonyms),
            ],
          ),
        ),
      ),
    );
  }

  wordRelation(String title, List<String>? setList) {
    if (setList?.isEmpty ?? false) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title : ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            setList!.toSet().toString().replaceAll("{", "").replaceAll("}", ""),
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(
            height: 10,
          )
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}
