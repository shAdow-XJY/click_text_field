import 'dart:collection';

class DAWGNode {
  final int id;
  final Map<String, DAWGNode> children;
  bool isFinal;

  DAWGNode(this.id) : children = {}, isFinal = false;

  void addChild(String key, DAWGNode child) {
    children[key] = child;
  }

  @override
  String toString() {
    var sb = StringBuffer();
    sb.write('Node $id [');
    for (var entry in children.entries) {
      sb.write('(${entry.key}, ${entry.value.id}) ');
    }
    sb.write('] ${isFinal ? "(final)" : ""}');
    return sb.toString();
  }
}

class DAWG {
  int _id;
  final DAWGNode _root;
  final Set<String> _finalNodes;

  DAWG() : _id = 0, _root = DAWGNode(0), _finalNodes = {};

  void addString(String s) {
    var node = _root;
    for (var i = 0; i < s.length; i++) {
      var c = s[i];
      if (!node.children.containsKey(c)) {
        _id++;
        var child = DAWGNode(_id);
        node.addChild(c, child);
        node = child;
      } else {
        node = node.children[c]!;
      }
    }
    node.isFinal = true;
    _finalNodes.add(s);
  }

  bool isPrefixMatched(String prefix) {
    var node = _root;
    for (var i = 0; i < prefix.length; i++) {
      var c = prefix[i];
      if (!node.children.containsKey(c)) {
        return false;
      } else {
        node = node.children[c]!;
      }
    }
    return true;
  }

  List<String> getPrefixMatches(String prefix) {
    var node = _root;
    for (var i = 0; i < prefix.length; i++) {
      var c = prefix[i];
      if (!node.children.containsKey(c)) {
        return [];
      } else {
        node = node.children[c]!;
      }
    }

    var matches = <String>[];
    _collectMatches(node, prefix, matches);
    return matches;
  }

  void _collectMatches(DAWGNode node, String prefix, List<String> matches) {
    if (node.isFinal) {
      matches.add(prefix);
    }
    for (var entry in node.children.entries) {
      var c = entry.key;
      var child = entry.value;
      _collectMatches(child, prefix + c, matches);
    }
  }

  void clear() {
    _id = 0;
    _root.children.clear();
    _finalNodes.clear();
  }

  void printDAWG() {
    var seen = <DAWGNode>{};
    var queue = Queue<DAWGNode>.from([_root]);
    while (queue.isNotEmpty) {
      var node = queue.removeFirst();
      seen.add(node);
      // print(node);

      for (var child in node.children.values) {
        if (!seen.contains(child)) {
          queue.add(child);
        }
      }
    }
  }
}
//这是一份DAGW(Directed Acyclic Graph of Words)数据结构的Dart语言实现代码。
//
//其中DAWGNode是DAGW的节点类，每个节点都有一个唯一的id和一个包含其所有子节点的Map对象children，以及一个bool类型的属性isFinal，用于表示该节点是否为某个单词的结束字符。
//
//DAWG是DAGW的主要类，其包含了一个私有的id计数器、一个根节点_root、一个包含所有结束字符的Set对象_finalNodes。它包含了三个主要的方法：
//
//addString(String s)，用于向DAGW中添加单词s。它首先从根节点开始遍历，如果当前节点的children中不包含s中的某个字符，则创建一个新的节点，否则继续遍历到该字符所在的节点。最后将该节点的isFinal属性设为true，并将s添加到_finalNodes中。
//
//isPrefixMatched(String prefix)，用于判断是否存在以prefix为前缀的单词。它同样从根节点开始遍历，如果在某个节点的children中找不到prefix中的某个字符，则返回false，否则继续遍历到该字符所在的节点。最后返回true。
//
//getPrefixMatches(String prefix)，用于获取所有以prefix为前缀的单词。它首先执行与isPrefixMatched相同的前缀匹配，然后遍历以该节点为根节点的子树，将所有以该节点为结束字符的单词加入到结果数组matches中。最后返回matches。
//
//除此之外，还有一个用于打印整个DAGW的printDAWG()方法。它使用了BFS算法遍历整个DAGW，并输出每个节点的信息。
//
//由于该DAGW是基于Trie树实现的，因此它的空间复杂度为O(mn)，其中m为单词数量，n为最长单词长度。添加单词和查找单词的时间复杂度均为O(n)，其中n为单词长度。因此，对于大规模的单词集合，该数据结构能够提供较高的效率和较小的空间占用。