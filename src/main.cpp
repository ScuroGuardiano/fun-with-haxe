#define CPPHTTPLIB_THREAD_POOL_COUNT 32 * 200

#include "hxhttplib/cpp-httplib.hpp"
#include <sstream>
#include <iostream>
#include <vector>
#include <mutex>
#include <algorithm>
#include "lib/json.hpp"

#define MAX_STORED_CATS 1000

using Json = nlohmann::json;

struct Cat {
    int id;
    std::string name;
    int age;

    static Cat fromJson(Json& json) {
        Cat cat;
        cat.id = json["id"];
        cat.name = json["name"];
        cat.age = json["age"];
        return cat;
    }

    std::unique_ptr<Json> toJson() {
        auto json = std::make_unique<Json>();
        (*json)["id"] = id;
        (*json)["name"] = name;
        (*json)["age"] = age;
        return json;
    }
};

int main() {
    httplib::Server http;
    std::vector<Cat> cats;
    std::mutex cats_m;

    http.Get(R"(/cats/(\d+))", [&](const httplib::Request& req, httplib::Response& res) {
        int catId = std::stoi(req.matches[1]);

        std::lock_guard lock(cats_m);
        auto catIt = std::find_if(cats.begin(), cats.end(), [catId](Cat& element) {
            return element.id == catId;
        });

        if (catIt == cats.end()) {
            res.status = 404;
            Json error;
            error["message"] = "404 - Not found";
            res.set_content(error.dump(), "application/json");
            return;
        }
        
        res.status = 200;
        res.set_content(catIt->toJson()->dump(), "application/json");
    });

    http.Post("/cats", [&](const httplib::Request& req, httplib::Response& res) {
        Json parsed = Json::parse(req.body);
        Cat cat = Cat::fromJson(parsed);
        std::unique_lock lock(cats_m);
        if (cats.size() >= MAX_STORED_CATS) {
            cats.erase(cats.begin());
        }
        cats.push_back(std::move(cat));
        // lock.unlock();
        res.status = 201;
        res.set_content(req.body, "application/json");
    });

    http.listen("0.0.0.0", 1337);
    std::cout << "Listening..." << std::endl;
}

    
    // http.Get(".*", [](const httplib::Request& req, httplib::Response& res) {
    //     res.status = 200;
    //     res.set_header("Content-Type", "application/json");
    //     std::stringstream body;
    //     body << "{"
    //          << R"("message": "Hello, world",)"
    //          << R"(
    //             "path": ")" << req.path << '"'
    //          << "}";

    //     res.body = body.str();
    // });