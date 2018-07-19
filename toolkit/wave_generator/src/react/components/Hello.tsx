import * as React from 'react';
import {test} from '../styles/Styles.css'

export interface HelloProps { compiler: string; framework: string; }

export class Hello extends React.Component<HelloProps, {}>
{
    render()
    {
        return (
            <h1 className={test}>
                Hello from {this.props.compiler} and {this.props.framework}
            </h1>
        );
    }
}
