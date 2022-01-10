import React from "react";

class ReadString extends React.Component {

    state = { dataKey: null };
    componentDidMount() {
        const { drizzle } = this.props;
        const contract = drizzle.contracts.NFTGiveaway;

        // let drizzle know we want to watch the `owner` method
        const dataKey = contract.methods["owner"].cacheCall();

        // save the `dataKey` to local component state for later reference
        this.setState({ dataKey })
    }

    render() {
        // get the contract state from drizzle state
        const { NFTGiveaway } = this.props.drizzleState.contracts;

        // using the saved `dataKey` get the variable we are interested in
        const owner = NFTGiveaway.owner[this.state.dataKey];

        // if it exists, then display its value
        return (
            <p>
                owner Value is::::::: {owner && owner.value}
            </p>
        )
    }
}

export default ReadString;