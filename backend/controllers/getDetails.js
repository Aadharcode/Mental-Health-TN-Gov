const { Psychiatrist, Teacher, Student, School } = require("../models/user");

const fetchDetails = async (req, res) => {
    const { collectionName } = req.body;
    console.log(collectionName);

    if (!collectionName) {
        return res.status(400).json({
            msg: "Collection name is required.",
        });
    }

    console.log(`Fetching details for collection: ${collectionName}`);  // Log the collection name

    try {
        let data;

        if (collectionName === "schools") {
            console.log("Querying schools...");
            data = await School.find({});
        } else if (collectionName === "teachers") {
            console.log("Querying teachers...");
            data = await Teacher.find({});
        } else if (collectionName === "psychiatrists") {
            console.log("Querying psychiatrists...");
            data = await Psychiatrist.find({});
        } else if (collectionName === "students") {
            console.log("Querying students...");
            data = await Student.find({});
        } else if (collectionName === "asa") {
            console.log("Querying students...");
            data = await Student.find({});
        } else if (collectionName === "cif") {
            console.log("Querying students...");
            data = await Student.find({});
        } else if (collectionName === "rc") {
            console.log("Querying students...");
            data = await Student.find({});
        } else if (collectionName === "warden") {
            console.log("Querying students...");
            data = await Student.find({});
        } else {
            console.log(`Invalid collection name: ${collectionName}`);
            return res.status(400).json({
                msg: `Invalid collection name: ${collectionName}`,
            });
        }

        console.log(`Fetched ${data.length} records from ${collectionName}`);  // Log number of records fetched

        return res.status(200).json({
            success: true,
            msg: `${collectionName} fetched successfully.`,
            data,
        });

    } catch (err) {
        console.error(`Error fetching ${collectionName}:`, err);  // Log the error for debugging
        res.status(500).json({
            msg: `An error occurred while fetching ${collectionName}`,
            error: err.message,
        });
    }
};

module.exports = fetchDetails;
